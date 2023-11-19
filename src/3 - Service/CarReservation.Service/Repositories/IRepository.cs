namespace CarReservation.Service.Repositories;

public interface IRepository<T, K> where T : class
{
    Task<T> Find(K id);
    Task<IEnumerable<T>> GetAll();
    Task Add(T entity);
    Task Delete(K id);
    Task Update(K id, T entity);
}
