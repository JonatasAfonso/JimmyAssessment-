namespace CarReservation.Domain.Entities;

using System.ComponentModel.DataAnnotations;

public class Car
{
    [Key]
    public string? UniqueIdentifier { get; set; }
    public string? Make { get; set; }
    public string? Model { get; set; }
}
