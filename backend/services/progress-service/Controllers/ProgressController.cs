using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProgressService.Data;
using ProgressService.Models;

namespace ProgressService.Controllers;

[ApiController]
[Route("api/progress")]
public class ProgressController(AppDbContext dbContext) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IEnumerable<ComplaintProgressDto>>> GetAllProgress()
    {
        var progress = await dbContext.Complaints
            .OrderByDescending(c => c.CreatedAtUtc)
            .Select(c => new ComplaintProgressDto
            {
                Id = c.Id,
                Title = c.Title,
                Location = c.Location,
                Category = c.Category,
                Status = c.Status,
                CreatedAtUtc = c.CreatedAtUtc,
                UpdatedAtUtc = c.UpdatedAtUtc
            })
            .ToListAsync();

        return Ok(progress);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<ComplaintProgressDto>> GetProgressById(int id)
    {
        var progress = await dbContext.Complaints
            .Where(c => c.Id == id)
            .Select(c => new ComplaintProgressDto
            {
                Id = c.Id,
                Title = c.Title,
                Location = c.Location,
                Category = c.Category,
                Status = c.Status,
                CreatedAtUtc = c.CreatedAtUtc,
                UpdatedAtUtc = c.UpdatedAtUtc
            })
            .FirstOrDefaultAsync();

        return progress is null ? NotFound() : Ok(progress);
    }
}
