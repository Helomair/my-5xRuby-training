
require 'capybara/rspec'
require "spec_helper"
require "rails_helper"
require 'database_cleaner'
ENV['RAILS_ENV'] = 'test'

DatabaseCleaner.strategy = :truncation

feature "Get into #index" do
#	DatabaseCleaner.clean
	let!(:task1)  {Task.create(id:"20",title:"title1",content:"content1",end_time:"2019-07-02T08:30",priority:"3")}
	let!(:task2)  {Task.create(id:"10",title:"title2",content:"content2",end_time:"2019-07-09T08:30",priority:"1")}
    scenario "should sorted by create time & priority" do
		visit "tasks"
		expect(page).to have_text("2019-07-02 08:30:00 +0800 編輯 刪除 title2")
	end
end

feature "Behaviors in #index" do
	# 0 => waiting  1 => processing  2 => done
	let!(:task1) {Task.create(title:"test1",status:"1")}
	let!(:task2) {Task.create(title:"test2",status:"2")}
	let!(:task3) {Task.create(title:"test3",status:"3")}

	scenario "fill_in search_box and search" do
		visit "tasks"
		fill_in "search", :with => "test1"
		click_button 'send_search'
		(expect(page).to_not have_text("test2")) && (expect(page).to_not have_text("test3")) && (expect(page).to have_text("test1"))
	end

	scenario "selected all" do
		visit "tasks"
		page.find("#all").click
		#click_button "waiting"
		(expect(page).to have_text("test2")) && (expect(page).to have_text("test3")) && (expect(page).to have_text("test1"))
	end

	scenario "selected waiting" do
		visit "tasks"
		page.find("#waiting").click
		#click_button "waiting"
		(expect(page).to_not have_text("test2")) && (expect(page).to_not have_text("test3"))
	end

	scenario "selected processing" do
		visit "tasks"
		page.find("#processing").click
		(expect(page).to_not have_text("test1")) && (expect(page).to_not have_text("test3"))
	end

	scenario "selected done" do
		visit "tasks"
		page.find("#done").click
		(expect(page).to_not have_text("test2")) && (expect(page).to_not have_text("test1"))
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
