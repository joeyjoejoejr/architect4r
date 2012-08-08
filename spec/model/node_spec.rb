require "spec_helper"

describe "Model Node" do
  
  subject { Person }
  
  describe :new do
    
    it { should respond_to(:new) }
    
    it "should accept a hash of properties with strings as keys" do
      piano = subject.new({ 'name' => 'Neo' })
      piano.should respond_to(:name)
      piano.name.should eql('Neo')
    end
    
    it "should accept a hash of properties with symbols as keys" do
      piano = subject.new({ :name => 'Neo' })
      piano.should respond_to(:name)
      piano.name.should eql('Neo')
    end
  end
  
  describe "#to_s" do
    
    it "should provide a more readable representation of the object" do
      person = Person.create(:name => 'Morpheus', :human => true)
      person.to_s.should == "#<Person:#{person.object_id} id=#{person.id} name='Morpheus' human='true' created_at='#{person.created_at}' updated_at='#{person.updated_at}' neo4j_uri='#{TEST_SERVER.node_url(person.id)}'>"
    end
    
    it "should provide readable representation of a new object" do
      person = Person.new(:name => 'Morpheus', :human => true)
      person.to_s.should == "#<Person:#{person.object_id} id=nil name='Morpheus' human='true' neo4j_uri=nil>"
    end
    
  end
  
  describe "equality of two instances of the same node" do
    
    subject { Person.create(:name => 'Alfons', :human => true) }
    let(:instance_1) { Person.find_by_id(subject.id) }
    let(:instance_2) { Person.find_by_id(subject.id) }
    
    it "should have the same hash" do
      instance_1.hash.should equal(instance_2.hash)
    end
    
    it "should be eql" do
      instance_1.should eql(instance_2)
    end
    
    it "should be ==" do
      instance_1.should == instance_2
    end
    
  end
  
  describe "connection" do
    
    it { should respond_to(:connection) }
    
    its(:connection) { should respond_to(:get) }
    
  end
  
  describe "node model_root" do
    
    it "should create a model_root node if there is none" do
      Person.create(:name => 'Morpheus', :human => true)
      Person.model_root.should_not be_nil
    end
    
    it "should reuse an existing model_root if there is already one" do
      Person.create(:name => 'Morpheus', :human => true)
      m_root = Person.model_root
      Person.create(:name => 'Trinity', :human => true)
      Person.model_root.id.should == m_root.id
    end
    
  end
  
end
