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
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを登録
        # Task.create!(title: "書類作成", content: "企画書を作成する。")  # 書き換え
        FactoryBot.create(:task)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content "書類作成"
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
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
        click_link "Show"
        # 遷移先のページで、task.contentの文字列を確認する
        expect(page).to have_content "書類作成"
        expect(page).to have_content "企画書を作成する。"
       end
     end
  end
end
