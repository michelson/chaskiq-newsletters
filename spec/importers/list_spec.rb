require "spec_helper"

module Chaskiq
  describe ListImporter do
    
    let(:spreadsheet_data) do
      arr = [] 
      arr << ['Email', ' Name ', 'last name', 'Department', 'Manager']
      (1..2).each{|o| 
          arr << [Faker::Name.name, 
           Faker::Internet.email, 
           Faker::Name.name,
           Faker::Company.bs,
           Faker::Nation.nationality]
         }

      arr
    end

    let(:spreadsheet_data_with_errors) do
      [
        ['List of Lists'],
        ['Name', 'Birth Date', 'Department', 'Manager'],
        ['John Doe', '2013-10-25', 'IT'],
        ['Invalid', '2013-10-24', 'Management'],
        ['Invalid', '2013-10-24', 'Accounting'],
        ['Jane Doe', '2013-10-26', 'Sales'],
      ]
    end

    let(:importer) { ListImporter.new('/dummy/file') }

    let(:list) {
      Chaskiq::List.create(name: "foo")
    }

    before do
      allow(Roo::Spreadsheet).to receive(:open).at_least(:once).and_return Spreadsheet.new(spreadsheet_data)
      ListImporter.instance_variable_set(:@fetch_model_block, nil)
      ListImporter.instance_variable_set(:@sheet_index, nil)
      ListImporter.transactional(false)
    end

    it 'imports all data from the spreadsheet into the model' do
       expect {ListImporter.import('/dummy/file', params: {list_id: list.id})}.to change(Subscriber, :count).by(2)
      #expect { ListImporter.import('/dummy/file') }.to change(List, :count).by(2)
    end

  end
end