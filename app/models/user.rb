# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_name  :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many :responses,
            foreign_key: :user_id,
            primary_key: :id,
            class_name:  :Response

  has_many :authored_polls,
            foreign_key: :author_id,
            primary_key: :id,
            class_name:  :Poll

  def completed_polls
    Poll
      .joins(questions: :answer_choices)
      .joins(<<-SQL)
        LEFT OUTER JOIN (
          SELECT * FROM responses WHERE responses.user_id = #{id}
          ) AS responses ON responses.answer_choice_id = answer_choices.id
        SQL
      .group('polls.id')
      .having('COALESCE(COUNT(DISTINCT questions.id), 0) = COALESCE(COUNT(responses.id), 0)')
  end

  def uncompleted_polls
    Poll
      .joins(questions: :answer_choices)
      .joins(<<-SQL)
        LEFT OUTER JOIN (
          SELECT * FROM responses WHERE responses.user_id = #{id}
          ) AS responses ON responses.answer_choice_id = answer_choices.id
        SQL
      .group('polls.id')
      .having('COALESCE(COUNT(DISTINCT questions.id), 0) > COUNT(responses.id)')
  end

end
