# userの作成
user = FactoryBot.create(:user)
admin = FactoryBot.create(:admin)


# 一般ユーザのtaskを作成
50.times do |i|
  Task.create!(title: "title_#{i +1}",
                content: "content_#{i +1}",
                created_at: (i +1).hour.ago,
                deadline_on: (i +1).days.from_now,
                priority: (i +1) % 3,
                status: (i +1) % 3,
                user_id: user.id )
end

# 管理者のタスクを作成
50.times do |i|
  Task.create!(title: "title_#{i +1}",
                content: "content_#{i +1}",
                created_at: (i +1).hour.ago,
                deadline_on: (i +1).days.from_now,
                priority: (i +1) % 3,
                status: (i +1) % 3,
                user_id: admin.id )
end