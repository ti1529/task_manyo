require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        # テストで使用するためのタスクの登録
        FactoryBot.create(:task)
        # 新規登録画面に遷移
        visit tasks_path
        # 登録したタスクのtitleとcontentの値の文字列が含まれていること（have_content）を確認する
        expect(page).to have_content "書類作成"
        expect(page).to have_content "企画書を作成する。"
      end
    end
  end

  describe '一覧表示機能' do

    let!(:first_task){ FactoryBot.create(:task, title: "first_task", created_at: Time.zone.local(2022, 2, 18))}
    let!(:second_task){ FactoryBot.create(:task, title: "second_task", created_at: Time.zone.local(2022, 2, 17))}
    let!(:third_task){ FactoryBot.create(:task, title: "third_task", created_at: Time.zone.local(2022, 2, 16))}

    before do
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        # 最初のtrについて、tdタグに first_task（作成日時が最新）が表示されていることを検証
        within all("tbody tr").first do
          expect(page).to have_selector "td", text: "first_task"
        end

        # 最後のtrについて、tdタグに third_task（作成日時が最も古い）が表示されていることを検証
        within all("tbody tr").last do
          expect(page).to have_selector "td", text: "third_task"
        end
      end
    end

    context '新たにタスクを作成した場合' do
      let!(:new_task){ FactoryBot.create(:task, title: "new_task")}
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        # 最初（一番上）のtrについて、tdタグに new_taskが表示されていることを検証
        within all("tbody tr").first do
          expect(page).to have_selector "td", text: "new_task"
        end
        
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        # テストで使用するためのタスクを登録
        FactoryBot.create(:task)
        # 一覧画面に遷移
        visit tasks_path
        # タスクのshowボタンをクリック
        find(".show-task").click
        # 遷移先のページで、task.contentの文字列を確認する
        expect(page).to have_content "書類作成"
        expect(page).to have_content "企画書を作成する。"
       end
     end
  end
end
