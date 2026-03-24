using CityComplaintApi.Data;
using CityComplaintApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CityComplaintApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ComplaintsController(AppDbContext dbContext) : ControllerBase
{
    private static readonly HashSet<string> ValidStatuses =
    ["Open", "In Progress", "Resolved", "Closed"];

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Complaint>>> GetAll()
    {
        var complaints = await dbContext.Complaints
            .OrderByDescending(c => c.CreatedAtUtc)
            .ToListAsync();

        return Ok(complaints);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<Complaint>> GetById(int id)
    {
        var complaint = await dbContext.Complaints.FindAsync(id);

        return complaint is null ? NotFound() : Ok(complaint);
    }

    [HttpPost]
    public async Task<ActionResult<Complaint>> Create([FromBody] CreateComplaintRequest request)
    {
        var complaint = new Complaint
        {
            Title = request.Title.Trim(),
            Description = request.Description.Trim(),
            Location = request.Location.Trim(),
            Category = request.Category.Trim(),
            Status = "Open"
        };

        dbContext.Complaints.Add(complaint);
        await dbContext.SaveChangesAsync();

        return CreatedAtAction(nameof(GetById), new { id = complaint.Id }, complaint);
    }

    [HttpPut("{id:int}/status")]
    public async Task<ActionResult<Complaint>> UpdateStatus(int id, [FromBody] UpdateComplaintStatusRequest request)
    {
        var normalizedStatus = request.Status.Trim();

        if (!ValidStatuses.Contains(normalizedStatus))
        {
            return BadRequest(new { error = "Invalid status. Use Open, In Progress, Resolved, or Closed." });
        }

        var complaint = await dbContext.Complaints.FindAsync(id);
        if (complaint is null)
        {
            return NotFound();
        }

        complaint.Status = normalizedStatus;
        await dbContext.SaveChangesAsync();

        return Ok(complaint);
    }
}
