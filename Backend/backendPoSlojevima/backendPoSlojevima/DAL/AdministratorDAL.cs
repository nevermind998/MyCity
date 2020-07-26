using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL
{
    public class AdministratorDAL : IAdministratorDAL
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly AuthRepository _auth;

        public AdministratorDAL(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            _auth = new AuthRepository(configuration);
        }

        public Korisnik dodajTokenKorisniku(Korisnik korisnik)
        {
            var response = _auth.CreateToken(korisnik);
            korisnik.Token = response;
          //  _context.korisnik.Update(korisnik);
            _context.SaveChanges();
            return korisnik;
        }

        public List<Korisnik> getAllAdministrator()
        {
            return _context.korisnik.Where(k => k.uloga == "admin" || k.uloga == "superuser").ToList();
        }
        public Korisnik unistiToken(Korisnik korisnik)
        {
            korisnik.Token = null;
           // _context.korisnik.Update(korisnik);
            _context.SaveChanges();
            return korisnik;

        }

        public Korisnik LoginCheck(Korisnik admin)
        {
            admin.username = admin.username.Trim();
            var check = _context.korisnik.FirstOrDefault(c => c.username.Equals(admin.username) && c.password.Equals(admin.password) && (c.uloga == "admin" || c.uloga == "superuser"));
        
            if (check == null) return null;
            check = this.dodajTokenKorisniku(check);
           
            return check;

        }

        public Korisnik getAdminById(long idKorisnika)
        {
            return _context.korisnik.FirstOrDefault(k => (k.uloga == "admin" || k.uloga == "superuser") && k.id == idKorisnika);
        }

    }
}
