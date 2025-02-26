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
        expect(page).to have_content "first_task_title"
        expect(page).to have_content "first_task_content"
      end
    end
  end

  describe '一覧表示機能' do

    let!(:first_task){ FactoryBot.create(:task)}
    let!(:second_task){ FactoryBot.create(:second_task)}
    let!(:third_task){ FactoryBot.create(:third_task)}

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
      let!(:new_task){ FactoryBot.create(:task, title: "new_task", created_at: Time.current)}
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        # 最初（一番上）のtrについて、tdタグに new_taskが表示されていることを検証
        within all("tbody tr").first do
          expect(page).to have_selector "td", text: "new_task"
        end
        
      end
    end


    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する

          # 終了期限というリンクをクリック
          click_link "終了期限"
          # tbodyのtrを取得
          # 最初がthird_task
          sleep 1
          within all("tbody tr").first do 
            expect(page).to have_selector "td", text: "third_task"
          end
          # 最後がfirst_task
          within all("tbody tr").last do
            expect(page).to have_selector "td", text: "first_task"
          end
        end
      end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する

          click_link "優先度"
          sleep 1
          within all("tbody tr").first do
            expect(page).to have_selector "td", text: "second_task_title"
          end
          within all("tbody tr").last do
            expect(page).to have_selector "td", text: "third_task_title"
          end
        end
      end
    end

    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          
          # 検索フォームのタイトル入力欄にfirstと入力
          fill_in "search_title", with: "first"
          # 検索フォームの検索ボタンをクリック
          find("#search_task").click
          # 画面上に、first_task_titleがあることを検証
          expect(page).to have_content "first_task_title"
          # 画面上に、second_task_titleがないことを検証
          expect(page).not_to have_content "second_task_title"
          # 画面上に、third_task_titleがないことを検証
          expect(page).not_to have_content "third_task_title"
        end
      end
      
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する

          # 検索フォームのステータスで着手中を選択
          select "着手中", from: "search_status"
          # 検索フォームの検索ボタンをクリック
          find("#search_task").click

          # タスクの一覧の中に
          within all("tbody").first do
            # 着手中があることを検証
            expect(page).to have_content "着手中"
            # 未着手がないことを検証
            expect(page).not_to have_content "未着手"
            # 完了がないことを検証
            expect(page).not_to have_content "完了"
          end       
        end
      end

      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する

          fill_in "search_title", with: "first"
          select "未着手", from: "search_status"
          # 検索フォームの検索ボタンをクリック
          find("#search_task").click

          # タスクの一覧の中に
          within all("tbody").first do
            # ステータスの検証
            expect(page).to have_content "未着手"
            expect(page).not_to have_content "着手中"
            expect(page).not_to have_content "完了"
            # タイトルの検証
            expect(page).to have_content "first_task_title"
            expect(page).not_to have_content "second_task_title"
            expect(page).not_to have_content "third_task_title"
          end       
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
        expect(page).to have_content "first_task_title"
        expect(page).to have_content "first_task_content"
       end
     end
  end
end
