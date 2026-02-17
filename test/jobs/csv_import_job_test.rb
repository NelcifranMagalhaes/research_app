require 'test_helper'

class CsvImportJobTest < ActiveJob::TestCase
  setup do
    @file_path = Rails.root.join('test', 'fixtures', 'files', 'sample.csv').to_s

    # Ensure the fixture file exists before each test
    unless File.exist?(@file_path)
      File.write(@file_path, <<~CSV)
        nome;email;email_corporativo;genero;geracao;tempo_de_empresa;n0_empresa;funcao;localidade;cargo;n1_diretoria;area;n3_coordenacao;n4_area;n2_gerencia;Data da Resposta;Interesse no Cargo
        John Doe;john@example.com;john@company.com;Male;Millennial;5 years;Company A;Developer;São Paulo;Senior Dev;Tech;Engineering;Backend;API;Development;2026-02-15;5
      CSV
    end
  end

  test 'should be enqueued' do
    assert_enqueued_jobs 0

    CsvImportJob.perform_later(@file_path)

    assert_enqueued_jobs 1
  end

  test 'should be in default queue' do
    CsvImportJob.perform_later(@file_path)

    assert_enqueued_with(job: CsvImportJob, queue: 'default')
  end

  test 'should process CSV file when performed' do
    temp_file = Rails.root.join('tmp', 'test_csv_process.csv').to_s
    FileUtils.cp(@file_path, temp_file)

    assert_difference [ 'Employee.count', 'Organization.count', 'Question.count' ], 1 do
      CsvImportJob.perform_now(temp_file)
    end
  end

  test 'should delete file after processing' do
    temp_file = Rails.root.join('tmp', 'test_csv_import.csv').to_s
    FileUtils.cp(@file_path, temp_file)

    assert File.exist?(temp_file)

    CsvImportJob.perform_now(temp_file)

    assert_not File.exist?(temp_file)
  end

  test 'should delete file even when processing fails' do
    temp_file = Rails.root.join('tmp', 'test_csv_import_error.csv').to_s
    File.write(temp_file, "invalid;csv\ndata;data")

    assert File.exist?(temp_file)

    begin
      CsvImportJob.perform_now(temp_file)
    rescue StandardError
    end

    assert_not File.exist?(temp_file)
  end

  test 'should raise error when file does not exist' do
    non_existent_file = '/tmp/non_existent_file.csv'

    assert_raises(Errno::ENOENT) do
      CsvImportJob.perform_now(non_existent_file)
    end
  end
end
