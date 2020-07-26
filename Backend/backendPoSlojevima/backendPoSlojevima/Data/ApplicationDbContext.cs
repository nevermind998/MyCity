using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.Data
{
    public class ApplicationDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite(@"Data source = database.db");
        }

        public DbSet<Slike> slike { get; set; }
        public DbSet<TekstualneObjave> tekstualne_objave { get; set; }
        public DbSet<Objave> objave { get; set; }
        public DbSet<TipObjave> tip_objave { get; set; }
        public DbSet<Komentari> komentari {get;set;}
        public DbSet<Korisnik> korisnik {get;set;}
        public DbSet<Lajkovi> lajkovi {get;set;}
        public DbSet<Report> report {get;set;}
        public DbSet<Grad> grad { get; set; }
        public DbSet<GradKorisnici> grad_korisnici { get; set; }
        public DbSet<Dislajkovi> dislajkovi { get; set; }
        public DbSet<ReportKomentari> reportKomentari { get; set; }
        public DbSet<LajkoviKomentara> lajkoviKomentari { get; set; }
        public DbSet<DislajkoviKomentari> dislajkoviKomentari { get; set; }
        public DbSet<Institucije> institucije { get; set; }
        public DbSet<RazlogPrijave> razlog_prijave { get; set; }
        public DbSet<KategorijeProblema> kategorija_problema { get; set; }
        public DbSet<ObjaveKategorije> objave_kategorije { get; set; }
        public DbSet<InstitucijeKategorije> institucije_kategorije { get; set; }
        public DbSet<LepeStvari> lepe_stvari { get; set; }
        public DbSet<Boje> gejmifikacija { get; set; }
        public DbSet<ObavestenjaLajkova> obavestenjaLajkovi { get; set; }
        public DbSet<ObavestenjaKomentari> obavestenjaKomentari { get; set; }
       

    }

}
