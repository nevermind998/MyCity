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
    public class ObavestenjaDAL : IObavestenjaDAL
    {
        private readonly ApplicationDbContext _context;

        public ObavestenjaDAL(ApplicationDbContext context)
        {
            _context = context;
        }

        public void dodajKomentar(Komentari komentar)
        {
            ObavestenjaKomentari obavestenje = new ObavestenjaKomentari();
            obavestenje.KomentarID = komentar.id;
            obavestenje.procitano = 0;
            _context.obavestenjaKomentari.Add(obavestenje);
            _context.SaveChanges();
        }

        public void dodajLajk(Lajkovi lajk)
        {
            ObavestenjaLajkova obavestenje = new ObavestenjaLajkova();
            obavestenje.LajkoviID = lajk.id;
            obavestenje.procitano = 0;
            _context.obavestenjaLajkovi.Add(obavestenje);
            _context.SaveChanges();
        }
        
        public List<ObavestenjaKomentari> getKomentareByIdVlasika(long idKorisnika)
        {
            return _context.obavestenjaKomentari.Where(o => o.komentar.objave.KorisnikID == idKorisnika && o.komentar.oznacenKaoResen == 0).ToList();
    
        }

        public List<ObavestenjaLajkova> getLajkoveByIdVlasika(long idKorisnika)
        {
           return _context.obavestenjaLajkovi.Include(o=> o.lajkovi).Where(o => o.lajkovi.objave.KorisnikID == idKorisnika ).ToList();
        }

        public Korisnik getKorisnikaByLajk(long idLajka)
        {
            var lajk = _context.lajkovi.FirstOrDefault(o => o.id == idLajka);
            return _context.korisnik.FirstOrDefault(k => k.id == lajk.KorisnikID);
        }
        public Korisnik getKorisnikByKomentar(long idKomentara)
        {
            var kom = _context.komentari.FirstOrDefault(o => o.id == idKomentara);
            return _context.korisnik.FirstOrDefault(k => k.id == kom.KorisnikID);
        }
       

        public List<ObavestenjaKomentari> getResenjaByIdVlasika(long idKorisnika)
        {
            return _context.obavestenjaKomentari.Where(o => o.komentar.objave.KorisnikID == idKorisnika && o.komentar.oznacenKaoResen > 0).ToList();
        }

        public Objave getObjavuByLajk(long idLajk)
        {
            var lajkovi = _context.lajkovi.FirstOrDefault(l => l.id == idLajk);
            return _context.objave.FirstOrDefault(o => o.id == lajkovi.ObjaveID);

        }
        public Objave getObjavuByKomentar(long idKomentara)
        {
            var kom = _context.komentari.FirstOrDefault(l => l.id == idKomentara);
            return _context.objave.FirstOrDefault(o => o.id == kom.ObjaveID);
        }
        public void removeLajk(Lajkovi lajk)
        {
            var obavestenje = _context.obavestenjaLajkovi.FirstOrDefault(o => o.LajkoviID == lajk.id);
            if (obavestenje != null)
            _context.obavestenjaLajkovi.Remove(obavestenje);
        }
            public void removeKomentar(Komentari komentar)
        {
            if (komentar != null )
            {
                var obavestenje = _context.obavestenjaKomentari.FirstOrDefault(o => o.KomentarID == komentar.id);
                if (obavestenje != null)
                _context.obavestenjaKomentari.Remove(obavestenje);
            }
          
        }

        public void procitano(long idKorisnika)
        {
            var listaLajkova = this.getLajkoveByIdVlasika(idKorisnika);
            var listaKomentara = this.getKomentareByIdVlasika(idKorisnika);
            var listaResenih = this.getResenjaByIdVlasika(idKorisnika);
            foreach(var item  in listaLajkova)
            {
                item.procitano = 1;
            }

            foreach (var item in listaKomentara)
            {
                item.procitano = 1;
            }
            foreach (var item in listaResenih)
            {
                item.procitano = 1;
            }


            _context.SaveChanges();
        }

        public long neprocitanaObavestenja(long idKorisnika)
        {
            var listaLajkova = this.getLajkoveByIdVlasika(idKorisnika);
            var listaKomentara = this.getKomentareByIdVlasika(idKorisnika);
            var listaResenih = this.getResenjaByIdVlasika(idKorisnika);

            long neprocitanih = 0;
            foreach (var item in listaLajkova)
            {
                if (item.procitano == 0) neprocitanih++;
            }

            foreach (var item in listaKomentara)
            {
                if (item.procitano == 0) neprocitanih++;
            }

            foreach (var item in listaResenih)
            {
                if (item.procitano == 0) neprocitanih++;
            }


            return neprocitanih;
        }
    }
}
