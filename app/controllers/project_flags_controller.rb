class ProjectFlagsController < ApplicationController
  # GET /project_flags
  # GET /project_flags.json
  def index
    @project_flags = ProjectFlag.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_flags }
    end
  end

  # GET /project_flags/1
  # GET /project_flags/1.json
  def show
    @project_flag = ProjectFlag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_flag }
    end
  end

  # GET /project_flags/new
  # GET /project_flags/new.json
  def new
    @project_flag = ProjectFlag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_flag }
    end
  end

  # GET /project_flags/1/edit
  def edit
    @project_flag = ProjectFlag.find(params[:id])
  end

  # POST /project_flags
  # POST /project_flags.json
  def create
    @project_flag = ProjectFlag.new(params[:project_flag])

    respond_to do |format|
      if @project_flag.save
        format.html { redirect_to @project_flag, notice: 'Project flag was successfully created.' }
        format.json { render json: @project_flag, status: :created, location: @project_flag }
      else
        format.html { render action: "new" }
        format.json { render json: @project_flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_flags/1
  # PUT /project_flags/1.json
  def update
    @project_flag = ProjectFlag.find(params[:id])

    respond_to do |format|
      if @project_flag.update_attributes(params[:project_flag])
        format.html { redirect_to @project_flag, notice: 'Project flag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_flags/1
  # DELETE /project_flags/1.json
  def destroy
    @project_flag = ProjectFlag.find(params[:id])
    @project_flag.destroy

    respond_to do |format|
      format.html { redirect_to project_flags_url }
      format.json { head :no_content }
    end
  end
end
