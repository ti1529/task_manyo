require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  let(:user) { FactoryBot.create(:user)}

  describe '登録機能' do

    before do
      visit new_user_path
    end

    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        # 名前、メールアドレス、パスワード、パスワード（確認）を入力
        user = FactoryBot.build(:user)
        fill_in "user_name", with: user.name
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        fill_in "user_password_confirmation", with: user.password_confirmation
        # 登録するボタンをクリック
        find("#create-user").click
        # userのタスク一覧画面であることを検証
        expect(current_path).to eq tasks_path
      end
    end

    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        # タスク一覧画面に遷移
        visit tasks_path
        # ログイン画面であることを検証
        expect(current_path).to eq new_session_path
        # 「ログインしてください」とう文字列があることを検証
        expect(page).to have_content "ログインしてください"
      end
    end
  end

  describe 'ログイン機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin) { FactoryBot.create(:admin) }
    context '登録済みのユーザでログインした場合' do
      # userでログインする
      before do
        visit new_session_path
        fill_in "session_email", with: user.email
        fill_in "session_password", with: user.password
        find("#create-session").click
      end

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(current_path).to eq tasks_path
        expect(page).to have_content "ログインしました"
      end

      it '自分の詳細画面にアクセスできる' do
        find("#account-setting").click
        expect(current_path).to eq user_path(user.id)
        expect(page).to have_content user.email
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(admin.id)
        expect(current_path).to eq tasks_path
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        find("#sign-out").click
        expect(current_path).to eq new_session_path
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe '管理者機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin) { FactoryBot.create(:admin) }

    context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in "session_email", with: admin.email
        fill_in "session_password", with: admin.password
        find("#create-session").click
      end

      it 'ユーザ一覧画面にアクセスできる' do
        # ユーザ一覧のリンクをクリック
        find("#users-index").click
        expect(current_path).to eq admin_users_path
      end

      it '管理者を登録できる' do
        # ユーザを登録する、をクリック
        find("#add-user").click
        # 各フォームに、新しいユーザ情報を入力
        fill_in "user_name", with: "admin_new"
        fill_in "user_email", with: "admin_new@mail.com"
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        check "user_admin"
        # 登録するをクリックする
        find("#create-user").click
        # ユーザ一覧ページに遷移し、「ユーザを登録しました」と表示されることを検証
        expect(current_path).to eq admin_users_path
        expect(page).to have_content "ユーザを登録しました"
      end

      it 'ユーザ詳細画面にアクセスできる' do
        # ユーザ一覧画面に遷移
        visit admin_users_path
        # userの詳細リンクをクリック
        click_link "詳細", href: admin_user_path(user.id)
        # ユーザ詳細ページに遷移したことを検証
        expect(current_path).to eq admin_user_path(user.id)
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit admin_users_path
        # userの編集リンクをクリック
        click_link "編集", href: edit_admin_user_path(user.id)
        # フォームに編集内容とパスワードを入力する
        fill_in "user_name", with: "#{user.name}_edit"
        fill_in "user_password", with: user.password
        fill_in "user_password_confirmation", with: user.password_confirmation
        # 更新するをクリック
        find("#update-user").click
        # ユーザ一覧ページに遷移し、「更新内容」と「ユーザを更新しました」、と表示されることを検証する
        expect(current_path).to eq admin_users_path
        expect(page).to have_content "ユーザを更新しました"
        expect(page).to have_content "#{user.name}_edit"

      end

      it 'ユーザを削除できる' do
        visit admin_users_path
        # userの削除リンクをクリックし、 確認のモーダルでokをクリック
        accept_confirm do
          click_link "削除", href: "/admin/users/#{user.id}"
        end
        # ユーザ一覧画面に遷移し、「ユーザを削除しました」と表示されること、削除したユーザのemailがないことを検証
        expect(current_path).to eq admin_users_path
        expect(page).to have_content "ユーザを削除しました"
        expect(page).not_to have_content user.email
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        visit new_session_path
        fill_in "session_email", with: user.email
        fill_in "session_password", with: user.password
        find("#create-session").click
        visit admin_users_path
      end

      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        expect(current_path).to eq tasks_path
        expect(page).to have_content "管理者以外アクセスできません"
      end
    end
  end
end
