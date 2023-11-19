//https://learn.microsoft.com/en-us/aspnet/core/tutorials/min-web-api?view=aspnetcore-8.0&tabs=visual-studio

using CarReservation.Domain.Dto;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    _ = app.UseSwagger();
    _ = app.UseSwaggerUI();
}

app.UseHttpsRedirection();


app.MapGet("/api/car/{id}", () =>
{
    var car = new CarOutputDto
    {
        UniqueIdentifier = Guid.NewGuid().ToString(),
        Make = "Ford",
        Model = "Fiesta"
    };
    return car;
})
.WithName("GetCarById")
.WithOpenApi();


app.MapGet("/api/cars", () =>
{
    var car = new CarOutputDto
    {
        UniqueIdentifier = Guid.NewGuid().ToString(),
        Make = "Ford",
        Model = "Fiesta"
    };
    var cars = new List<CarOutputDto> { car };
    return cars.ToArray();
})
.WithName("GetCars")
.WithOpenApi();


app.MapPost("/api/car", async (CarInputDto car) =>
{
    return Results.Created($"api/car/{Guid.NewGuid()}", car);
})
.WithName("PostCar")
.WithOpenApi();


app.MapDelete("/api/car", async (string id) =>
{
    return Results.NoContent();
})
.WithName("DeleteCar")
.WithOpenApi();


app.MapPut("/api/car/{id}", async (int id, CarInputDto inputcar) =>
{
    return Results.NoContent();
})
.WithName("UpdateCar")
.WithOpenApi();


app.Run();
