using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Web_.Net_Assignment_With_Authentication.Models;

namespace Web_.Net_Assignment_With_Authentication.Data
{
    public class ApplicationDbContext : IdentityDbContext
    {
        public DbSet<Models.Record> records { get; set; }
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
    }
}
