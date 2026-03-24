using CityComplaintApi.Models;
using Microsoft.EntityFrameworkCore;

namespace CityComplaintApi.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Complaint> Complaints => Set<Complaint>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Complaint>(entity =>
        {
            entity.HasKey(c => c.Id);
            entity.Property(c => c.Status).HasDefaultValue("Open");
            entity.Property(c => c.CreatedAtUtc).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });
    }
}
