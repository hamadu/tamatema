require 'spec_helper'

describe Count do
  let(:glossary) { FactoryGirl.create(:glossary) }
  
  before {
    @count = Count.new(
      week: 0,
      total: 0,
      glossary_id: glossary.id
    )
  }
  subject { @count }
  
  it { should respond_to(:week) }
  it { should respond_to(:total) }
  it { should respond_to(:glossary_id) }
  it { should respond_to(:glossary) }
end
