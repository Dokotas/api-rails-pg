class Api::V1::CompaniesController < ApplicationController
  before_action :set_company, only: %i[show update destroy mark_deleted]

  # GET /v1/companies
  # GET /v1/companies?name=Mo&location=New — фильтр по имени и месту
  def index
    companies = Company.active.by_name(params[:name]).by_location(params[:location])
    render json: { companies: companies.as_json(except: %i[created_at updated_at]) }
  end

  # GET /v1/companies/:id
  def show
    render json: @company
  end

  # POST /v1/companies
  def create
    company = Company.new(company_params)
    if company.save
      render json: company, status: :created
    else
      render json: { company: company.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  # PUT /v1/companies/:id
  def update
    if @company.update(company_params)
      render json: @company
    else
      render json: { company: @company.errors, status: :unprocessable_entity },
             status: :unprocessable_entity
    end
  end

  # DELETE /v1/companies/:id — физическое удаление
  def destroy
    @company.destroy
    render json: { deleted_company: @company.as_json(only: %i[id name location]),
                   code: 200, status: :success }
  end

  # PUT /v1/companies/:id/mark_deleted — «мягкое» удаление (Глава 7)
  def mark_deleted
    if @company.deleted
      render json: { deleted_company: [], deleted_already: :not_modified }
    else
      @company.delete_company
      render json: { deleted_company: @company.as_json(except: %i[created_at updated_at]),
                     code: 200, status: :success }
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.permit(:name, :location)
  end
end
