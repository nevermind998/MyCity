using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Data;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using System.Data.Entity;

namespace backendPoSlojevima.DAL
{
    public class GradKorisniciDAL : IGradKorisniciDAL
    {
        private readonly ApplicationDbContext _context;
        private readonly IGradDAL _IGradDAL;
        private readonly IKorisnikDAL _IKorisnikDAL;

        public GradKorisniciDAL(ApplicationDbContext context, IGradDAL IGradDAL, IKorisnikDAL IKorisnikDAL)
        {
            _context = context;
            _IGradDAL = IGradDAL;
            _IKorisnikDAL = IKorisnikDAL;
        }

        public void dodajGradKorisnika(long idKorisnika, long idGrada)
        {
           // if (_IKorisnikDAL.proveraIdKorisnika(idKorisnika) != 1 || _IGradDAL.proveraIdGrada(idGrada) != 1)  return;
            GradKorisnici gradKorisnici = new GradKorisnici();
            gradKorisnici.GradID = idGrada;
            gradKorisnici.KorisnikID = idKorisnika;
            _context.grad_korisnici.Add(gradKorisnici);
            _context.SaveChanges();
        }

        public void dodajViseGradovaZaKorisnika(long idKorisnika, List<long> nizGradova)
        {
            //if (_IKorisnikDAL.proveraIdKorisnika(idKorisnika) != 1) return;
            List<GradKorisnici> lista = new List<GradKorisnici>();
            foreach(var idGrada in nizGradova)
            {
               // if( _IGradDAL.proveraIdGrada(idGrada) == 1)
                {
                    GradKorisnici gradKorisnici = new GradKorisnici();
                    gradKorisnici.GradID = idGrada;
                    gradKorisnici.KorisnikID = idKorisnika;
                    _context.grad_korisnici.Add(gradKorisnici);
                }
                
            }
           _context.SaveChanges();
        }

        

        public List<GradKorisnici> getAllGradKorisnici()
        {
            return _context.grad_korisnici.Include(g => g.korisnik).Include(g => g.grad).ToList();
        }

        public void deleteGradoveZaKorisnika(long idKorisnika)
        {
            var lista = _context.grad_korisnici.Where(k => k.KorisnikID == idKorisnika);
            if (lista == null) return ;
            _context.grad_korisnici.RemoveRange(lista);
            _context.SaveChanges();
        }
        public void izmeniGradoveZaKorisnika(long idKorisnika, List<long> nizGradova)
        {
            if (nizGradova != null )
            {
                this.deleteGradoveZaKorisnika(idKorisnika);
                this.dodajViseGradovaZaKorisnika(idKorisnika, nizGradova);
            }
            
        }
    }
}
