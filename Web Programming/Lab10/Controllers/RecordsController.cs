using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.CodeAnalysis.Elfie.Model.Strings;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Web_.Net_Assignment_With_Authentication.Data;
using Web_.Net_Assignment_With_Authentication.Models;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Web_.Net_Assignment_With_Authentication.Controllers
{
    [Authorize]
    public class RecordsController : Controller
    {
        private readonly ApplicationDbContext _context;

        private readonly UserManager<IdentityUser> _userManager;

        private readonly RoleManager<IdentityRole> _roleManager;

        // Every endpoint which is only available to the administrator should look like this:
        /*
          var user = await UserManager.GetUserAsync(User);
          var role = await RoleManager.FindByNameAsync("administrator"); //not needed, only for debugging
          var userRoles = await UserManager.GetRolesAsync(user);
          if (userRoles.Contains("administrator"))
          {
                //do something
          }
         */


        public RecordsController(ApplicationDbContext context, UserManager<IdentityUser> userManager,
            RoleManager<IdentityRole> roleManager)
        {
            _context = context;
            _userManager = userManager;
            _roleManager = roleManager;
        }

        // GET: Records
        public async Task<IActionResult> Index()
        {
            return View(await _context.records.ToListAsync());
        }

        public async Task<IActionResult> AdministratorMainPage()
        {
            return View("AdministratorMainPage");
        }

        public async Task<IActionResult> ClientMainPage()
        {
            return View("ClientMainPage");
        }

        // GET: 'Records/GetRecords?pageNumber=' + pageNumber + '&sortingType=' + sortingType
        public async Task<string> GetRecords(int pageNumber, string sortingType) // 1-based index
        {
            const int PAGE_SIZE = 3;
            List<Record> records;
            
            if (sortingType == "byTitle")
                records = await _context.records.
                Skip((pageNumber-1) * PAGE_SIZE).
                Take(PAGE_SIZE).
                OrderBy(r => r.Title).
                ToListAsync();
            else if (sortingType == "byAuthor")
                records = await _context.records.
                Skip((pageNumber - 1) * PAGE_SIZE).
                Take(PAGE_SIZE).
                OrderBy(r => r.Email).
                ToListAsync();
            else
                records = await _context.records.
                Skip((pageNumber - 1) * PAGE_SIZE).
                Take(PAGE_SIZE).
                ToListAsync();
            return JsonSerializer.Serialize(records);
        }

        //POST: Records/Add
        [HttpPost]
        public async Task<string> Add(string author, string title, string comment)
        {
            Record record = new Record
            {
                Id = Guid.NewGuid(),
                Email = author,
                Title = title,
                Comment = comment,
                Date = DateTime.Now
            };
            _context.Add(record);
            var response = await _context.SaveChangesAsync();
            return JsonSerializer.Serialize(response);
        }

        // POST: Records/Delete/5
        [HttpDelete, ActionName("Delete")]
        public async Task<string> Delete(Guid id)
        {
            var record = await _context.records.FindAsync(id);
            //return JsonSerializer.Serialize(record);
            if (record != null)
            {
                 _context.Remove(record);
            }
            var response = await _context.SaveChangesAsync();
            return JsonSerializer.Serialize(response);
        }

        // GET: Records/Update/5
        [HttpPut, ActionName("Update")]
        public async Task<string> Update(Guid id, Record @record)
        {
            if (id != @record.Id)
            {
                return JsonSerializer.Serialize("Bad input");
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(@record);
                    var response = await _context.SaveChangesAsync();
                    return JsonSerializer.Serialize(response);
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!RecordExists(@record.Id))
                    {
                        return JsonSerializer.Serialize(NotFound());
                    }
                    else
                    {
                        throw;
                    }
                }
            }
            return JsonSerializer.Serialize("Model state is not valid");
        }

        // GET: Records/Details/5
        public async Task<IActionResult> Details(Guid? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var @record = await _context.records
                .FirstOrDefaultAsync(m => m.Id == id);
            if (@record == null)
            {
                return NotFound();
            }

            return View(@record);
        }

        // GET: Records/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Records/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Email,Title,Comment,Date")] Record @record)
        {
            if (ModelState.IsValid)
            {
                @record.Id = Guid.NewGuid();
                _context.Add(@record);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(@record);
        }

        // GET: Records/Edit/5
        public async Task<IActionResult> Edit(Guid? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var @record = await _context.records.FindAsync(id);
            if (@record == null)
            {
                return NotFound();
            }
            return View(@record);
        }

        // POST: Records/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(Guid id, [Bind("Id,Email,Title,Comment,Date")] Record @record)
        {
            if (id != @record.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(@record);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!RecordExists(@record.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(@record);
        }

        // GET: Records/Delete/5
        /*public async Task<IActionResult> Delete(Guid? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var @record = await _context.records
                .FirstOrDefaultAsync(m => m.Id == id);
            if (@record == null)
            {
                return NotFound();
            }

            return View(@record);
        }*/

        // POST: Records/Delete/5
        //[HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(Guid id)
        {
            var @record = await _context.records.FindAsync(id);
            if (@record != null)
            {
                _context.records.Remove(@record);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool RecordExists(Guid id)
        {
            return _context.records.Any(e => e.Id == id);
        }
    }
}
