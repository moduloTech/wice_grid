# encoding: utf-8
require 'acceptance_helper'

describe 'XLSX export WiceGrid', type: :request, js: true do
  before :each do
    visit '/xlsx_export'
  end

  it 'should export xlsx' do
    find(:css, 'button.wg-external-xlsx-export-button').click
    expect(page).to have_content('ID;Title;Priority;Status;Project Name;')
  end
end
