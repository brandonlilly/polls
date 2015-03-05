# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all
Question.destroy_all
AnswerChoice.destroy_all
Response.destroy_all
Poll.destroy_all


100.times do |i|
  user = User.create!(user_name: "user_#{i}")
end

user_ids = User.pluck(:id)
10.times do |j|
  poll = Poll.create!(title: "title_#{j}", author_id: user_ids.sample)

  10.times do |n|
    question = Question.create!(text: "How do you spell #{n}?", poll_id: poll.id)

    ('A'..'D').each do |answer|
      answer_choice = AnswerChoice.create!(
        text: "#{answer}: Choice whatever",
        question_id: question.id
      )
    end
  end
end

choices = AnswerChoice.pluck(:id)
choices.each do |choice_id|
  ids = user_ids.dup.shuffle
  rand(10).times do
    begin
      Response.create!(user_id: ids.pop, answer_choice_id: choice_id)
    rescue ActiveRecord::RecordInvalid
      retry
    end
  end
end

ru = User.create!(user_name: 'considering')
pp = Poll.create!(title: 'finished', author_id: 2)
questions = 4.times.map do |n|
  Question.create!(text: "Do you like the number #{n}?", poll_id: pp.id)
end
questions.each do |question|
  answer_choices = ('A'..'D').map do |answer|
    AnswerChoice.create!(
      text: "#{answer}: Choice whatever",
      question_id: question.id
    )
  end
  Response.create!(user_id: ru.id, answer_choice_id: answer_choices.sample.id)
end
