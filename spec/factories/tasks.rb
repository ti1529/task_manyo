# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
  factory :task do
    title { 'first_task_title' }
    content { 'first_task_content' }
    created_at { Time.zone.local(2022, 2, 18) }
    deadline_on { "2022-02-18".to_date }
    priority { 1 }
    status { 0 }
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task, class: Task do
    title { 'second_task_title' }
    content { 'second_task_content' }
    created_at { Time.zone.local(2022, 2, 17) }
    deadline_on { "2022-02-17".to_date }
    priority { 2 }
    status { 1 }
  end

  factory :third_task, class: Task do
    title { 'third_task_title' }
    content { 'third_task_content' }
    created_at { Time.zone.local(2022, 2, 16) }
    deadline_on { "2022-02-16".to_date }
    priority { 0 }
    status { 2 }
  end
end
