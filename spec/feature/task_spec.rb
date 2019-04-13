require 'capybara/rspec'
require "rails_helper"
require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

feature "Start test" do

	let!(:user) {User.create(name:"admin",password:"admin",permission:"admin")}
	let!(:user2) {User.create(name:"user2",password:"user",permission:"user")}

	feature "Login test" do
		scenario "login succeed" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"
			expect(page).to have_text("登入成功")
		end
		scenario "login failed" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "1234"
			click_button "login"
			expect(page).to have_text("登入失敗")
		end
		scenario "Logout" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"
			expect(page).to have_text("登入成功", wait: 10)
			page.find("#logout_button").click
			expect(page).to have_text("Please log in")
		end
	end
	feature "Send request, create new artical" do
		scenario "Can't visit without login, and redirect to login" do
			visit "/tasks/new"
			expect(page).to have_text("Please log in")
		end
		scenario "Logged in and can send, title not nil" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"
			visit "tasks/new"
			fill_in 'task_title', :with => "Testing title"
			fill_in 'task_content', :with => "Testing content"
			fill_in 'task_end_time', :with => "2019-07-09T08:30"
			click_button 'save'
			expect(page).to have_text("Testing title")
		end
		scenario "Logged in and can send, but title is nil" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"
			visit "tasks/new"
			fill_in 'task_title', :with => ""
			fill_in 'task_content', :with => "Testing content"
			fill_in 'task_end_time', :with => "2019-07-09T08:30"
			click_button 'save'
			expect(page).to(have_text("標題不可為空")) || expect(page).to(have_text("Title connot be null")) 
		end
	end

	feature "Get into #index" do
	#	DatabaseCleaner.clean
		let(:task1)  {Task.new(id:"20",title:"title1",content:"content1",end_time:"2019-07-02T08:30",priority:"3")}
		let(:task2)  {Task.new(id:"10",title:"title2",content:"content2",end_time:"2019-07-09T08:30",priority:"1")}
		let(:task3)  {Task.new(id:"30",title:"title3",content:"content3",end_time:"2019-07-09T08:30",priority:"2")}
		before :each do
			user.tasks = [task1, task2]
			user2.tasks << task3
		end
	    scenario "should sorted by create time & priority, only have user's tasks" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"
			expect(page).to(have_content("2019-07-02 08:30:00 +0800 編輯 刪除 title2")) && expect(page).to_not(have_text("title3"))
		end
	end

	feature "Behaviors in #index" do
		# 0 => waiting  1 => processing  2 => done
		let(:task1) {Task.new(title:"test1",status:"1")}
		let(:task2) {Task.new(title:"test2",status:"2")}
		let(:task3) {Task.new(title:"test3",status:"3")}
		before :each do
			user.tasks = [task1, task2, task3]
		end
		scenario "fill_in search_box and search" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"

			visit "tasks"
			fill_in "search", :with => "test1"
			click_button 'send_search'
			(expect(page).to_not have_text("test2")) && (expect(page).to_not have_text("test3")) && (expect(page).to have_text("test1"))
		end

		scenario "selected all" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"

			visit "tasks"
			page.find("#all").click
			#click_button "waiting"
			(expect(page).to have_text("test2")) && (expect(page).to have_text("test3")) && (expect(page).to have_text("test1"))
		end

		scenario "selected waiting" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"

			visit "tasks"
			page.find("#waiting").click
			#click_button "waiting"
			(expect(page).to_not have_text("test2")) && (expect(page).to_not have_text("test3"))
		end

		scenario "selected processing" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"

			visit "tasks"
			page.find("#processing").click
			(expect(page).to_not have_text("test1")) && (expect(page).to_not have_text("test3"))
		end

		scenario "selected done" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"

			visit "tasks"
			page.find("#done").click
			(expect(page).to_not have_text("test2")) && (expect(page).to_not have_text("test1"))
		end
	end

	feature "Get into #edit, edit file" do
		let(:task) {Task.new(title:"Testing title",content:"Testing content")}
		before :each do
	        user.tasks << task
		end

		scenario "Can't visit without login, and redirect to login" do
			visit "tasks/#{task.id}/edit"
			expect(page).to have_text("Please log in")
		end
		scenario "Logged in and can send, title not nil" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"

			visit "tasks/#{task.id}/edit"
			fill_in 'task_title', :with => "edit title"
			fill_in 'task_content', :with => "edit content"
			click_button 'save'
			expect(page).to_not(have_text("Testing title")) && expect(page).to(have_text("edit title"))
		end
		scenario "Logged in and can send, but title is nil" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"

			visit "tasks/#{task.id}/edit"
			fill_in 'task_title', :with => ""
			fill_in 'task_content', :with => "edit content"
			click_button 'save'
			expect(page).to(have_text("標題不可為空")) || expect(page).to(have_text("Title connot be null")) 
		end
	end

	feature "DELETE a task" do
		let(:task) {Task.new(title:"Testing title",content:"Testing content")}
		before :each do
	        user.tasks << task
		end

		scenario "Can't send delete to tasks/{task.id} without Login" do
	        page.driver.delete("/tasks/#{task.id}")
	        expect(page).to have_text("redirected")
		end
		scenario "Send delete to tasks/{task.id}, Logged in" do
			visit "login"
			fill_in "name", :with => "admin"
			fill_in "password", :with => "admin"
			click_button "login"

	        page.driver.delete("/tasks/#{task.id}")
	        expect(page).to have_text("redirected.")
		end
	end

end
