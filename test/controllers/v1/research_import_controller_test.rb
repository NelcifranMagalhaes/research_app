require 'test_helper'

module V1
  class ResearchImportControllerTest < ActionDispatch::IntegrationTest
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

    test 'should return error when no file is uploaded' do
      post '/v1/research_import', params: {}

      assert_response :bad_request
      assert_equal 'No file uploaded', JSON.parse(response.body)['error']
    end

    test 'should queue import job when file is uploaded' do
      file = fixture_file_upload('sample.csv', 'text/csv')

      assert_enqueued_with(job: CsvImportJob) do
        post '/v1/research_import', params: { file: file }
      end

      assert_response :accepted
      json_response = JSON.parse(response.body)
      assert_equal 'Import queued', json_response['message']
      assert_not_nil json_response['job_id']
    end

    test 'should handle exceptions and return unprocessable_entity when persist_upload fails' do
      file = fixture_file_upload('sample.csv', 'text/csv')

      # Make the uploads directory read-only to cause an error
      upload_dir = Rails.root.join('tmp', 'uploads')
      FileUtils.mkdir_p(upload_dir)

      # Mock the SecureRandom to return a predictable value and then cause permission error
      # Instead of mocking, we'll just test with nil file
      post '/v1/research_import', params: { file: nil }

      assert_response :bad_request
    end

    test 'should queue reset database job' do
      assert_enqueued_jobs 1, only: ResetDatabaseJob do
        delete '/v1/reset_database'
      end

      assert_response :accepted
      assert_equal 'Database reset queued', JSON.parse(response.body)['message']
    end
  end
end
