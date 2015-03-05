# == Schema Information
#
# Table name: answer_choices
#
#  id          :integer          not null, primary key
#  text        :text             not null
#  question_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class AnswerChoice < ActiveRecord::Base
  validates :text, :question_id, presence: true

  has_many :responses,
           foreign_key: :answer_choice_id,
           primary_key: :id,
           class_name: :Response

  belongs_to :question,
             foreign_key: :question_id,
             primary_key: :id,
             class_name: :Question
end
