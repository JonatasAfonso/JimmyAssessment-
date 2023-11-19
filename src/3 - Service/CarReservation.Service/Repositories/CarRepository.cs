namespace CarReservation.Service.Repositories;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using CarReservation.Domain.Dto;

public class CarRepository : IRepository<CarInputDto, string>
{
    async Task IRepository<CarInputDto, string>.Add(CarInputDto entity) => throw new NotImplementedException();
    async Task IRepository<CarInputDto, string>.Delete(string id) => throw new NotImplementedException();
    async Task<CarInputDto> IRepository<CarInputDto, string>.Find(string id) => throw new NotImplementedException();    async Task<IEnumerable<CarInputDto>> IRepository<CarInputDto, string>.GetAll() => throw new NotImplementedException();
    async Task IRepository<CarInputDto, string>.Update(string id, CarInputDto entity) => throw new NotImplementedException();
}
