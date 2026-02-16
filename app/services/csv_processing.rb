require 'csv'

class CsvProcessing
  def initialize(file_path)
    @file_path = file_path
    @employee = nil
    @organization = nil
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
    @employee = Employees::CreateUseCase.new(employee_params).execute
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
    @organization = Organizations::CreateUseCase.new(organization_params).execute
  end

  def create_survey_response(row)
    Question.all.each do |question|
      survey_response_params = {
        employee_id: @employee.id,
        organization_id: @organization.id,
        question_id: question.id,
        answer_date: row['Data da Resposta'],
        score: row[question.theme],
        comment: row["Comentários - #{question.theme}"]
      }
      SurveyResponses::CreateUseCase.new(survey_response_params).execute
    end
  end
end
