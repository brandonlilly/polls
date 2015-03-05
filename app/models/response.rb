# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  answer_choice_id :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question,
           :respondent_can_not_respond_to_own_poll

  belongs_to :answer_choice,
              foreign_key: :answer_choice_id,
              primary_key: :id,
              class_name:  :AnswerChoice

  belongs_to :respondent,
              foreign_key: :user_id,
              primary_key: :id,
              class_name:  :User

  has_one :question, through: :answer_choice, source: :question

  def sibling_responses
    responses = question.responses
    if id.nil?
      responses
    else
      responses.where('responses.id != ?', id)
    end
  end

  private

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(user_id: user_id)
      errors[:respondent] << "can't respond to poll multiple times"
    end
  end

  def respondent_can_not_respond_to_own_poll
    if answer_choice.question.poll.exists?(author_id: user_id)
      errors[:respondent] << "can't respond to own poll"
    end
  end

end
