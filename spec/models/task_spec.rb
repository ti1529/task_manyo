require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        # task = Task.create(title: "", content: "企画書を作成する。")
        task = FactoryBot.build(:task, title: "")
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, content: "")
        expect(task).not_to be_valid
      end
    end

    context 'タスクの期限が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, deadline_on: "")
        expect(task).not_to be_valid
      end
    end

    context 'タスクの優先度が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, priority: "")
        expect(task).not_to be_valid
      end
    end

    context 'タスクのステータスが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = FactoryBot.build(:task, status: "")
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトル、説明、期限、優先度、ステータスに値が入っている場合' do
      it 'タスクを登録できる' do
        task = FactoryBot.build(:task)
        expect(task.save).to be_truthy
      end
    end
  end

  describe '検索機能' do
    # テストデータを作成
    let!(:first_task){ FactoryBot.create(:task, title: "first_task_title", deadline_on: "2022-02-18".to_date, priority: 1, status: 0)}
    let!(:second_task){ FactoryBot.create(:second_task, title: "second_task_title", deadline_on: "2022-02-17".to_date, priority: 2, status: 1)}
    let!(:third_task){ FactoryBot.create(:third_task, title: "third_task_title", deadline_on: "2022-02-16".to_date, priority: 0, status: 2)}

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する

        tasks = Task.search_by_title("first")

        expect(tasks).to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks).not_to include(third_task)
        expect(tasks.count).to eq 1
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        tasks = Task.search_by_status(0)

        expect(tasks).to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks).not_to include(third_task)
        expect(tasks.count).to eq 1

      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        tasks = Task.search_by_title("first").search_by_status(0)

        expect(tasks).to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks).not_to include(third_task)
        expect(tasks.count).to eq 1

      end
    end
  end

end
