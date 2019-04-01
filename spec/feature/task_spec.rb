require "spec_helper.rb"
require "rails_helper"
require 'capybara/rspec'

feature "Get into #index" do
	scenario "should sorted by create time" do
		task1 = Task.create(id:"20",title:"title1",content:"content1")
		task2 = Task.create(id:"10",title:"title2",content:"content2")
		visit "tasks"
		page.text.should match("content1 編輯 刪除 title2")
	end
end


feature "Get into #new make new task" do
	scenario "User visit #new & send request" do
		visit "tasks/new"
		fill_in 'task_title', :with => "Testing title"
		fill_in 'task_content', :with => "Testing content"
		click_button 'save'
		expect(page).to have_text("Testing title")
    end
end

feature "Get into #edit edit task" do
	scenario "User visit #edit & send request" do
        task = Task.create(title:"Testing title",content:"Testing content")
        visit "tasks/#{task.id}/edit"
		fill_in 'task_title', :with => "edit title"
		fill_in 'task_content', :with => "edit content"
		click_button 'save'
		expect(page).to have_text("edit title")
	end
end

feature "DELETE a task" do
	scenario "send delete to tasks/1" do
         task = Task.create(title:"Testing title",content:"Testing content")
         page.driver.delete("/tasks/#{task.id}")
        expect(page).to have_text("redirected.")
	end
end
