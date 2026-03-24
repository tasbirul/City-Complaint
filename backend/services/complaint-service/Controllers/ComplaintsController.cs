using ComplaintService.Data;
using ComplaintService.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace ComplaintService.Controllers;

[ApiController]
[Route("api/complaints")]
public class ComplaintsController(AppDbContext dbContext) : ControllerBase
{
    [HttpPost]
    public async Task<ActionResult<Complaint>> Create([FromBody] CreateComplaintRequest request)
    {
        var complaint = new Complaint
        {
            Title = request.Title.Trim(),
            Description = request.Description.Trim(),
            Location = request.Location.Trim(),
            Category = request.Category.Trim(),
            Status = "Open",
            UpdatedAtUtc = DateTime.UtcNow
        };

        dbContext.Complaints.Add(complaint);
        await dbContext.SaveChangesAsync();

        return Created($"/api/complaints/{complaint.Id}", complaint);
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Complaint>>> GetAll()
    {
        var complaints = await dbContext.Complaints
            .OrderByDescending(c => c.CreatedAtUtc)
            .ToListAsync();

        return Ok(complaints);
    }
}
