require 'spec_helper'

describe UrlsController ,type: :controller do
  describe 'get#index' do
    context 'no params' do
      it 'render right template' do
        get :index
        expect(response.status).to eq 200
        expect(response).to render_template(:index)
        expect(flash).to_not be_present
        #expect(assigns(:long_url)).to eq([])
      end
    end
  end
  describe "post#create" do
    context "with valid parameters" do
      xit "should create new entry and load show template" do
        post :create, params: {long_url: "www.example.com/#{Faker::Name.first_name}"}
        expect(response.status).to eq 200
        expect(response).to render_template(:show)
        expect(flash["success"]).to match("success")
      end
      xit "should show the duplicate entried record and not create" do
        post :create, params: {long_url: "www.example.com/"}
        expect(response.status).to eq 200
        expect(response).to render_template(:show)
        expect(flash["notice"]).to match("shortend URL already exits!")
      end
    end
    context "with invalid parameters" do
      xit "should redirect to index template if invalid url is given" do
        post :create, params: {long_url: "{Faker::Name.first_name}"}
        expect(response.status).to eq 200
        expect(response).to render_template(:index)
        expect(flash["error"].to_s).to match("invalid url format")
      end
    end
  end
  describe "get#show" do
    context "with valid parameters" do
      xit "should show the right values" do
        url = Url.last
        get :show, params: {id: url.id}
        expect(response.status).to eq 200
        expect(response).to render_template(:show)
        expect(url.short_url).to eq url.short_url
      end
    end
    context "with invalid parameters" do
      xit "should redirect to index template if invalid id is given" do
        get :show, params: {id: -24}
        expect(response.status).to eq 302
        expect(flash["error"].to_s).to match("Record does not exists")
      end
    end
  end
  describe "get#redirect" do
    context "with valid parameters" do
      xit "should redirect to the long url" do
        url = Url.last
        get :redirect, params: {short_url: url.short_url}
        expect(response.status).to eq 302
        expect(flash).to_not be_present
        expect(url.click_stats.count).to be >= 1
      end
    end
    context "with invalid parameters" do
      xit "should redirect to index template if invalid id is given" do
        get :redirect, params: {short_url: "0000000"}
        expect(response.status).to eq 302
        expect(flash["error"].to_s).to match("Sorry no URL found")
      end
    end    
  end

  describe "API url_stats" do
        context "with valid parameters" do
      it "should give all the stats related to the given long_url" do
        url = ClickStat.last.url
        get :url_stats, params: {url_type: "long",url:url.long_url}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)["response"]).to eq "success"
      end
      it "should give all the stats related to the given short_url" do
        url = ClickStat.last.url
        get :url_stats, params: {url_type: "short",url:url.short_url}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)["response"]).to eq "success"
      end
    end
    context "with invalid parameters" do
      it "should give response as failure and proper message" do
        get :url_stats, params: {url_type: "short",url:"000000"}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)["response"]).to eq "failure"
      end
    end 
  end
end
