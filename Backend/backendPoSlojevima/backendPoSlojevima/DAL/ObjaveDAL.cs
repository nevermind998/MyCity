using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.Data;
using System.Data.Entity;

namespace backendPoSlojevima.DAL
{
    public class ObjaveDAL : IObjaveDAL
    {
        private readonly ApplicationDbContext _context;
        private readonly IObjaveKategorijaDAL _IObjaveKategorijaDAL;

        public ObjaveDAL(ApplicationDbContext context, IObjaveKategorijaDAL IObjaveKategorijaDAL)
        {
            _context = context;
            _IObjaveKategorijaDAL = IObjaveKategorijaDAL;
        }
        public List<Objave> getAllObjave()
        {
            return _context.objave.ToList();
        }

        public void saveObjavu(PrihvatanjeObjave data)
        {
            long id = _context.objave.Count();
            if (id == 0)
            {
                id = 1;
            }
            else
            {
                id = _context.objave.Max(o => o.id) + 1;
            }
            data.id = id;
            Objave objava = new Objave();
            objava.id = id;
            objava.KorisnikID = data.idKorisnika;
            objava.idTipa = data.tip;
            objava.GradID = data.idGrada;
            objava.resenaObjava = 0;
            objava.vreme = DateTime.Now;
            objava.LepaStvarID = data.LepaStvarID;
            _context.objave.Add(objava);
            objava.korisnik.poeni += 5;
            _context.SaveChanges();
            if (objava.LepaStvarID == 0)
            _IObjaveKategorijaDAL.dodajObjaviKategoriju(data);
        }

       

        public void deleteObjave(List<Objave> objave)
        {
            if (objave != null)
            {
                _context.objave.RemoveRange(objave);
                _context.SaveChanges();
            }

        }

        public void deleteObjavu(Objave objava,int ind)
        {
            if (objava != null)
            {
                if (ind == 1) objava.korisnik.poeni -= 10;
                else   objava.korisnik.poeni -= 1;
                if (objava.korisnik.poeni < 0) objava.korisnik.poeni = 0;
                _context.objave.Remove(objava);
                _context.SaveChanges();
            }
        }

        public Objave problemResen(Objave objava,long ind)
        {
            if (objava.resenaObjava == 0)
            {
                if (ind != 1) objava.korisnik.poeni += 10;
                objava.resenaObjava = ind; //institucija koja je resila problem, za korisnika se pamti 1; (id institucije nikad nije 1, zbog glavnog administratora)
                _context.objave.Update(objava);
                _context.SaveChanges();
                return objava;
            }
            return null;
        }

        public List<KategorijeProblema> getKategorijeProblema()
        {
            return _context.kategorija_problema.ToList();
        }
        public List<LepeStvari> getLepeStavri()
        {
            return _context.lepe_stvari.Where(l => l.id > 0).ToList();
        }

        public LepeStvari getLepeStavriById(long LepeStavriID)
        {
            return _context.lepe_stvari.FirstOrDefault(l => l.id == LepeStavriID);
        }
    }
}
