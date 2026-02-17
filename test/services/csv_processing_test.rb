require 'test_helper'

class CsvProcessingTest < ActiveSupport::TestCase
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

  test 'should initialize with file path' do
    csv_processing = CsvProcessing.new(@file_path)

    assert_not_nil csv_processing
  end

  test 'should create questions from CSV headers' do
    csv_processing = CsvProcessing.new(@file_path)

    assert_difference 'Question.count', 1 do
      csv_processing.process
    end

    assert Question.exists?(theme: 'Interesse no Cargo')
  end

  test 'should create employee from CSV row' do
    csv_processing = CsvProcessing.new(@file_path)

    assert_difference 'Employee.count', 1 do
      csv_processing.process
    end

    employee = Employee.last
    assert_equal 'John Doe', employee.name
    assert_equal 'john@example.com', employee.personal_email
    assert_equal 'john@company.com', employee.corporate_email
  end

  test 'should create organization from CSV row' do
    csv_processing = CsvProcessing.new(@file_path)

    assert_difference 'Organization.count', 1 do
      csv_processing.process
    end

    organization = Organization.last
    assert_equal 'Company A', organization.company_name
    assert_equal 'Developer', organization.company_role
  end

  test 'should create survey responses from CSV row' do
    csv_processing = CsvProcessing.new(@file_path)

    initial_survey_count = SurveyResponse.count
    initial_question_count = Question.count

    csv_processing.process

    new_questions = Question.count - initial_question_count
    assert_equal 1, new_questions

    total_questions = Question.count
    expected_responses = initial_survey_count + total_questions

    assert_equal expected_responses, SurveyResponse.count
    assert SurveyResponse.exists?(score: 5)
  end

  test 'should process multiple rows' do
    # Create a CSV file with multiple rows
    multi_row_file = Rails.root.join('tmp', 'test_multi_row.csv').to_s
    CSV.open(multi_row_file, 'w', col_sep: ';') do |csv|
      csv << [ 'nome', 'email', 'email_corporativo', 'genero', 'geracao', 'tempo_de_empresa',
              'n0_empresa', 'funcao', 'localidade', 'cargo', 'n1_diretoria', 'area',
              'n3_coordenacao', 'n4_area', 'n2_gerencia', 'Data da Resposta', 'Interesse no Cargo' ]
      csv << [ 'John Doe', 'john@example.com', 'john@company.com', 'Male', 'Millennial', '5 years',
              'Company A', 'Developer', 'São Paulo', 'Senior Dev', 'Tech', 'Engineering',
              'Backend', 'API', 'Development', '2026-02-15', '5' ]
      csv << [ 'Jane Smith', 'jane@example.com', 'jane@company.com', 'Female', 'Gen Z', '2 years',
              'Company B', 'Designer', 'Rio de Janeiro', 'Junior Designer', 'Design', 'Creative',
              'UI/UX', 'Frontend', 'Design Team', '2026-02-15', '4' ]
    end

    csv_processing = CsvProcessing.new(multi_row_file)

    assert_difference 'Employee.count', 2 do
      assert_difference 'Organization.count', 2 do
        csv_processing.process
      end
    end

    # Clean up
    File.delete(multi_row_file) if File.exist?(multi_row_file)
  end
end
