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
    public class ObjaveKategorijeDAL : IObjaveKategorijaDAL
    {
        private readonly ApplicationDbContext _context;

        public ObjaveKategorijeDAL (ApplicationDbContext context)
        {
            _context = context;
        }
        public void dodajObjaviKategoriju(PrihvatanjeObjave objava)
        {
            foreach(var kategorija in objava.idKategorija)
            {
                ObjaveKategorije objaveKategorija = new ObjaveKategorije();
                long id = _context.objave_kategorije.Count();
                if (id == 0)
                {
                    objaveKategorija.id = 1;
                }
                else
                {
                    objaveKategorija.id = _context.objave_kategorije.Max(o => o.id) + 1;
                }
                objaveKategorija.ObjaveID = objava.id;
                objaveKategorija.KategorijaID = kategorija;
              
                _context.objave_kategorije.Add(objaveKategorija);
                _context.SaveChanges();
            }

           
        }

        public List<ObjaveKategorije> getAllObjaveKategorije()
        {
            return _context.objave_kategorije.ToList();
        }

        public List<KategorijeProblema> getKategorijeByIdObjave(long idObjave)
        {
            var check = _context.objave_kategorije.Where(o => o.ObjaveID == idObjave).Select(o => o.kategorija).ToList();
           
            if (check != null) return check;
            else return null;
        }
    }
}
