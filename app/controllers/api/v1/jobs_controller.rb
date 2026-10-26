class Api::V1::JobsController < ApplicationController
  before_action :set_job, only: %i[show update destroy]

  # GET /v1/jobs?name=&place=  и  GET /v1/companies/:company_id/jobs
  def index
    jobs = params[:company_id] ? Company.find(params[:company_id]).jobs : Job.all
    jobs = jobs.by_name(params[:name]).by_place(params[:place])
    render json: { jobs: jobs.as_json(except: %i[created_at updated_at]) }
  end

  def show
    render json: @job
  end

  def create
    job = Job.new(job_params)
    if job.save
      render json: job, status: :created
    else
      render json: { job: job.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  def update
    if @job.update(job_params)
      render json: @job
    else
      render json: { job: @job.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy
    render json: { deleted_job: @job.as_json(only: %i[id name place]), code: 200, status: :success }
  end

  private

  def set_job
    scope = params[:company_id] ? Company.find(params[:company_id]).jobs : Job
    @job = scope.find(params[:id])
  end

  def job_params
    params.permit(:name, :place, :company_id)
  end
end
