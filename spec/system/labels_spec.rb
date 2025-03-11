require 'rails_helper'
RSpec.describe 'ラベル管理機能', type: :system do
  let!(:user){ FactoryBot.create(:user)}

  describe '登録機能' do
    before do
      visit new_session_path
      fill_in "session_email", with: user.email
      fill_in "session_password", with: user.password
      find("#create-session").click
    end

    context 'ラベルを登録した場合' do
      let(:label_new) { user.labels.new(name: "label_new") }
      before do
        visit new_label_path
        fill_in "label_name", with: label_new.name 
        find("#create-label").click
      end

      it '登録したラベルが表示される' do
        expect(page).to have_selector "#notice", text: "ラベルを登録しました"
        expect(page).to have_content label_new.name
      end
    end
  end
  
  describe '一覧表示機能' do
    let!(:label){ user.labels.create(name: "label_name")}
    before do
      visit new_session_path
      fill_in "session_email", with: user.email
      fill_in "session_password", with: user.password
      find("#create-session").click
    end

    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        visit labels_path 
        expect(page).to have_content label.name
      end
    end
  end
end
