10.times do |i|
  Task.create!(title: "title_#{i +1}",
                content: "content_#{i +1}",
                deadline_on: (i +1).days.from_now,
                priority: (i +1) % 3,
                status: (i +1) % 3,
                )
end