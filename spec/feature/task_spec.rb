require "spec_helper.rb"
require "rails_helper"
require 'capybara/rspec'

feature "Get into #index" do
	scenario "should sorted by create time" do
		task1 = Task.create(id:"20",title:"title1",content:"content1",end_time:"2019-07-02T08:30")
		task2 = Task.create(id:"10",title:"title2",content:"content2",end_time:"2019-07-09T08:30")
		visit "tasks"
		expect(page).to have_text("2019-07-02 08:30:00 +0800 編輯 刪除 title2")
		#expect(page.text).to match(/^\d{task1.title}:d{task2.title}/)
	end
end


feature "Get into #new make new task" do
	scenario "User visit #new & send request & title not nil" do
		visit "tasks/new"
		fill_in 'task_title', :with => "Testing title"
		fill_in 'task_content', :with => "Testing content"
		fill_in 'task_end_time', :with => "2019-07-09T08:30"
		click_button 'save'
		expect(page).to have_text("Testing title")
    end
    scenario "User visit #new & send request & title is nil" do
		visit "tasks/new"
		fill_in 'task_title', :with => ""
		fill_in 'task_content', :with => "Testing content"
		fill_in 'task_end_time', :with => "2019-07-09T08:30"
		click_button 'save'
		expect(page).to(have_text("標題不可為空")) || expect(page).to(have_text("Title connot be null")) 
    end
end

feature "Get into #edit edit task" do
	scenario "User visit #edit & send request" do
        task = Task.create(title:"Testing title",content:"Testing content")
        visit "tasks/#{task.id}/edit"
		fill_in 'task_title', :with => "edit title"
		fill_in 'task_content', :with => "edit content"
		fill_in 'task_end_time', :with => "2019-07-09T08:30"
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
