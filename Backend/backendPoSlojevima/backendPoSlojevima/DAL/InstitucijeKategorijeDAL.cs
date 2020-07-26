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
    public class InstitucijeKategorijeDAL : IInstitucijeKategorijeDAL
    {
        private readonly ApplicationDbContext _context;

        public InstitucijeKategorijeDAL(ApplicationDbContext context)
        {
            _context = context;
        }

        public void deleteKategorijeZaKorisnika(long idKorisnika)
        {
            var lista = _context.institucije_kategorije.Where(k => k.InstitucijaID == idKorisnika);
            if (lista == null) return;
            _context.institucije_kategorije.RemoveRange(lista);
            _context.SaveChanges();
        }

        public void dodajInstitucijiKategoriju(PrihvatanjeKategorije data)
        {
            foreach (var kategorija in data.idKategorije)
            {
                InstitucijeKategorije institucijeKategorije = new InstitucijeKategorije();
                long id = _context.institucije_kategorije.Count();
                if (id == 0)
                {
                    institucijeKategorije.id = 1;
                }
                else
                {
                    institucijeKategorije.id = _context.institucije_kategorije.Max(o => o.id) + 1;
                }
                institucijeKategorije.InstitucijaID = data.institucija.id;
                institucijeKategorije.KategorijaID = kategorija;

                _context.institucije_kategorije.Add(institucijeKategorije);
                _context.SaveChanges();
            }

        }

        public void dodajViseKategorijaZaKorisnika(long idKorisnika, List<long> kategorije)
        {
            List<InstitucijeKategorije> lista = new List<InstitucijeKategorije>();
            foreach (var id in kategorije)
            {
          
                    InstitucijeKategorije institucijaKategorija = new InstitucijeKategorije();
                    institucijaKategorija.KategorijaID = id;
                    institucijaKategorija.InstitucijaID = idKorisnika;
                    _context.institucije_kategorije.Add(institucijaKategorija);
    
            }
            _context.SaveChanges();
        }

        public List<InstitucijeKategorije> getAllInstitucijeKategorije()
        {
            return _context.institucije_kategorije.Include(i => i.institucija).Include(i => i.kategorija).ToList();
            
        }

        public int izmeniKategorijeZaKorisnika(long idKorisnika, List<long> kategorije)
        {
            if (kategorije != null)
            {
                this.deleteKategorijeZaKorisnika(idKorisnika);
                this.dodajViseKategorijaZaKorisnika(idKorisnika, kategorije);
                return 1;
            }
            return 0;
        }
    }
}
