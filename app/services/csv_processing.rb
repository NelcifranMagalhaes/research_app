require 'csv'

class CsvProcessing
  def initialize(file_path)
    @file_path = file_path
  end

  def process
    create_questions
    CSV.foreach(@file_path, headers: true, col_sep: ';') do |row|
      create_employee(row)
      create_organization(row)
      create_survey_response(row)
    end
  end

  private

  def create_questions
    headers = CSV.read(@file_path, headers: true, col_sep: ';').headers
    start_index = headers.index('Interesse no Cargo')
    headers = headers[start_index..]
    headers.each do |header|
      question_params = {
        theme: header
      }
      Questions::CreateUseCase.new(question_params).execute
    end
  end

  def create_employee(row)
    employee_params = {
      name: row['nome'],
      personal_email: row['email'],
      corporate_email: row['email_corporativo'],
      gender: row['genero'],
      generation: row['geracao'],
      company_tenure: row['tempo_de_empresa']
    }
    Employees::CreateUseCase.new(employee_params).execute
  end

  def create_organization(row)
    organization_params = {
      company_name: row['n0_empresa'],
      company_role: row['funcao'],
      localization: row['localidade'],
      job_title: row['cargo'],
      board: row['n1_diretoria'],
      department: row['area'],
      management: row['n3_coordenacao'],
      area: row['n4_area'],
      administration: row['n2_gerencia']
    }
    Organizations::CreateUseCase.new(organization_params).execute
  end

  def create_survey_response(row)
    survey_response_params = {
      employee_id: Employee.find_by(personal_email: row['email'])&.id,
      organization_id: Organization.find_by(company_name: row['n0_empresa'])&.id,
      question_id: Question.find_by(theme: 'Interesse no Cargo')&.id,
      answer_date: row['Data da Resposta'],
      score: row['Interesse no Cargo'],
      comment: row['comentario']
    }
    SurveyResponses::CreateUseCase.new(survey_response_params).execute
  end
end
