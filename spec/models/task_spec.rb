require 'rails_helper'

RSpec.describe Task, type: :model do
	it "title is nil" do
		task = Task.new(title: nil)
		expect(task).to_not be_valid
	end
	it "title is not nil" do
		task = Task.new(title: "testing")
		expect(task).to be_valid
	end
	it "search title" do
		task = Task.create(title: "Test1")
		task2 = Task.where(title: "Test1")
		expect(task2).to_not be_nil
	end
#  pending "add some examples to (or delete) #{__FILE__}"
end
