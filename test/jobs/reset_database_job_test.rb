require 'test_helper'

class ResetDatabaseJobTest < ActiveJob::TestCase
  test 'should be enqueued' do
    assert_enqueued_jobs 0

    ResetDatabaseJob.perform_later

    assert_enqueued_jobs 1
  end

  test 'should be in default queue' do
    ResetDatabaseJob.perform_later

    assert_enqueued_with(job: ResetDatabaseJob, queue: 'default')
  end

  test 'should delete all survey responses' do
    employee = employees(:one)
    organization = organizations(:one)
    question = questions(:one)

    SurveyResponse.create!(
      employee: employee,
      organization: organization,
      question: question,
      answer_date: Date.today,
      score: 5
    )

    assert SurveyResponse.count > 0

    ResetDatabaseJob.perform_now

    assert_equal 0, SurveyResponse.count
  end

  test 'should delete all questions' do
    assert Question.count > 0

    ResetDatabaseJob.perform_now

    assert_equal 0, Question.count
  end

  test 'should delete all employees' do
    assert Employee.count > 0

    ResetDatabaseJob.perform_now

    assert_equal 0, Employee.count
  end

  test 'should delete all organizations' do
    assert Organization.count > 0

    ResetDatabaseJob.perform_now

    assert_equal 0, Organization.count
  end

  test 'should delete all records in correct order' do
    # Create some test data
    employee = employees(:one)
    organization = organizations(:one)
    question = questions(:one)

    SurveyResponse.create!(
      employee: employee,
      organization: organization,
      question: question,
      answer_date: Date.today,
      score: 5
    )

    initial_survey_responses = SurveyResponse.count
    initial_questions = Question.count
    initial_employees = Employee.count
    initial_organizations = Organization.count

    assert initial_survey_responses > 0
    assert initial_questions > 0
    assert initial_employees > 0
    assert initial_organizations > 0

    ResetDatabaseJob.perform_now

    assert_equal 0, SurveyResponse.count
    assert_equal 0, Question.count
    assert_equal 0, Employee.count
    assert_equal 0, Organization.count
  end
end
