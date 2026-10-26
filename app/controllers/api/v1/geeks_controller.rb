class Api::V1::GeeksController < ApplicationController
  before_action :set_geek, only: %i[show update destroy attach_resume]

  # GET /v1/geeks?name=&stack=
  # GET /v1/jobs/:job_id/geeks          — соискатели на вакансию
  # GET /v1/companies/:company_id/geeks — соискатели на компанию
  def index
    geeks =
      if params[:job_id]        then Job.find(params[:job_id]).geeks
      elsif params[:company_id] then Company.find(params[:company_id]).geeks
      else Geek.all
      end
    geeks = geeks.by_name(params[:name]).by_stack(params[:stack])
    render json: { geeks: geeks.as_json(except: %i[created_at updated_at]) }
  end

  # GET /v1/geeks/:id
  def show
    render json: @geek
  end

  # POST /v1/geeks
  def create
    geek = Geek.new(geek_params)
    if geek.save
      render json: geek, status: :created
    else
      render json: { geek: geek.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  # PUT /v1/geeks/:id
  def update
    if @geek.update(geek_params)
      render json: @geek
    else
      render json: { geek: @geek.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  # DELETE /v1/geeks/:id
  def destroy
    @geek.destroy
    render json: { deleted_geek: @geek.as_json(only: %i[id name stack]),
                   code: 200, status: :success }
  end

  # PUT /v1/geeks/:id/resume
  def attach_resume
    if @geek.update(resume: params.require(:resume))
      render json: @geek
    else
      render json: { geek: @geek.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  private

  def set_geek
    @geek = Geek.find(params[:id])
  end

  def geek_params
    params.permit(:name, :stack, :resume)
  end
end
