# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :text             not null
#  poll_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Question < ActiveRecord::Base
  validates :text, :poll_id, presence: true

  has_many :answer_choices,
           foreign_key: :question_id,
           primary_key: :id,
           class_name:  :AnswerChoice,
           dependent:   :destroy

  belongs_to :poll,
             foreign_key: :poll_id,
             primary_key: :id,
             class_name:  :Poll

  has_many :responses, through: :answer_choices, source: :responses

  def results
    response_counts = {}
    choices = answer_choices
      .select('answer_choices.*, COALESCE(COUNT(responses.id), 0) AS response_count')
      .joins('LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id')
      .group('answer_choices.id')

    choices.each do |choice|
      response_counts[choice.text] = choice.response_count
    end
    response_counts
  end
end
