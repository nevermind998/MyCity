using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.Data;

namespace backendPoSlojevima.DAL
{
    public class TekstualneObjaveDAL : ITekstualneObjaveDAL
    {
         private readonly ApplicationDbContext _context;

         public TekstualneObjaveDAL(ApplicationDbContext context)
         {
                _context = context;
         }

        public void deleteTekstualneObjave(List<TekstualneObjave> objave)
        {
            if (objave != null)
            {
                _context.tekstualne_objave.RemoveRange(objave);
                _context.SaveChanges();
            }
           
        }

        public void deleteTekstualnuObjavu(TekstualneObjave objava)
        {
            if(objava != null)
            {
                _context.tekstualne_objave.Remove(objava);
                _context.SaveChanges();
            }
      
        }

        public List<TekstualneObjave> getAllTekstualneObjave()
        {
            return _context.tekstualne_objave.ToList();
        }

        public void izmenaTekstualneObjave(TekstualneObjave izmena)
        {
            var objava = _context.tekstualne_objave.FirstOrDefault(o => o.ObjaveID == izmena.ObjaveID);
            if (objava == null) return;
            objava.tekst = izmena.tekst;
           // _context.tekstualne_objave.Update(objava);
            _context.SaveChanges();
        }

        public void saveTekstualnuObjavu(String text)
        {
            TekstualneObjave objava = new TekstualneObjave();
            objava.tekst = text;
            var id = _context.objave.Count();
            if (id == 0)
            {
                objava.ObjaveID = 1;
            }
            else
            {
                objava.ObjaveID = _context.objave.Max(o => o.id);
            }
            id = _context.tekstualne_objave.Count();
            if (id == 0)
            {
                objava.id = _context.tekstualne_objave.Count() + 1;
            }
            else
            {
                objava.id = _context.tekstualne_objave.Max(o => o.id) + 1;
            }


            _context.tekstualne_objave.Add(objava);
            _context.SaveChanges();
        }

        
    }
}
