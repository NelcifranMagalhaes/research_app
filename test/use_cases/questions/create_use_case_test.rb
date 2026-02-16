require 'test_helper'

module Questions
  class CreateUseCaseTest < ActiveSupport::TestCase
    test 'should create question with valid params' do
      params = {
        theme: 'Interesse no Cargo'
      }

      use_case = Questions::CreateUseCase.new(params)
      question = use_case.execute

      assert_not_nil question
      assert_equal 'Interesse no Cargo', question.theme
      assert_empty use_case.errors
    end

test 'should create question even with empty params' do
    params = {}

    use_case = Questions::CreateUseCase.new(params)
    question = use_case.execute

    assert_not_nil question
    assert_empty use_case.errors
    end

    test 'should persist question to database' do
      params = {
        theme: 'New Question Theme'
      }

      use_case = Questions::CreateUseCase.new(params)

      assert_difference 'Question.count', 1 do
        use_case.execute
      end
    end
  end
end
