50.times do |i|
  Task.create!(title: "title_#{i +1}", content: "content_#{i +1}")
end