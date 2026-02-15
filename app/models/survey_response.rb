class SurveyResponse < ApplicationRecord
  belongs_to :employee_id
  belongs_to :organization_id
  belongs_to :question_id
end
