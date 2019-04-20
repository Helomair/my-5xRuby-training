require 'rails_helper'

RSpec.describe Task, type: :model do
	let(:user) {User.create(name:"admin",password:"admin",permission:"admin")}
	it "title is nil" do
		task = Task.new(title: nil,user_id:"1")
		user.tasks << task
		expect(task).to_not be_valid
	end
	it "title is not nil" do
		
		task = Task.new(title: "testing")
		user.tasks << task
		expect(task).to be_valid
	end
	it "search title" do
		task = Task.create(title: "Test1",user_id:"1")
		user.tasks << task
		task2 = Task.where(title: "Test1",user_id:"1")
		expect(task2).to_not be_nil
	end
#  pending "add some examples to (or delete) #{__FILE__}"
end
