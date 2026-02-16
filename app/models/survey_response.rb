class SurveyResponse < ApplicationRecord
  belongs_to :employee
  belongs_to :organization
  belongs_to :question
end
